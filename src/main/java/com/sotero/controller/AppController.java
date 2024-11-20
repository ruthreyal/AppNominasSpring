package com.sotero.controller;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import com.sotero.model.Empleado;
import com.sotero.service.EmpleadoService;

@Controller
@RequestMapping("/")
public class AppController {

    @Autowired
    private EmpleadoService empleadoService;

    @GetMapping("/index")
    public String inicio() {
        return "index"; // Ruta de la vista de inicio
    }

    @GetMapping("/listar")
    public String mostrarEmpleados(Model model) {
        List<Empleado> empleados = empleadoService.obtenerTodosLosEmpleados();
        System.out.println("Empleados obtenidos: " + empleados.size());
        if (empleados.isEmpty()) {
            model.addAttribute("mensajeError", "No se encontraron empleados.");
        }
        
        model.addAttribute("empleados", empleados);
        return "listar";
    }

    @GetMapping("/buscarSueldo")
    public String buscarSalario() {
        return "buscarSueldo"; // Vista del formulario para buscar salario
    }

    @PostMapping("/resultadoSueldo")
    public String mostrarSalario(@RequestParam String dni, Model model) {
        System.out.println("DEBUG: DNI recibido: " + dni);

        Optional<Integer> salarioOpt = empleadoService.obtenerSalarioPorDni(dni);

        if (salarioOpt.isPresent()) {
            System.out.println("DEBUG: Salario encontrado: " + salarioOpt.get());
            model.addAttribute("salario", salarioOpt.get());
        } else {
            System.out.println("DEBUG: No se encontró un salario para el DNI: " + dni);
            model.addAttribute("mensajeError", "No se encontró un empleado con el DNI proporcionado.");
        }

        model.addAttribute("dni", dni);
        return "resultadoSueldo";
    }

    @GetMapping("/buscarEmpleado")
    public String buscarEmpleados() {
        return "buscarEmpleado"; // Vista del formulario para buscar empleados con filtros
    }

    @PostMapping("/empleadosFiltrados")
    public String mostrarEmpleadosFiltrados(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String dni,
            @RequestParam(required = false) String sexo,
            @RequestParam(required = false) Integer categoria,
            @RequestParam(required = false) Integer anyos,
            Model model) {

        // Crear la especificación de filtrado
        var spec = empleadoService.crearFiltro(nombre, dni, sexo, categoria, anyos);

        // Obtener empleados filtrados
        List<Empleado> empleados = empleadoService.filtrarEmpleados(spec);

        model.addAttribute("empleados", empleados);
        return "listar";
    }

    @PostMapping ("/editarEmpleado")
    public String modificarEmpleado(@RequestParam String dni, Model model) {
        Empleado empleadoOpt = empleadoService.buscarEmpleadoPorDni(dni);
        model.addAttribute("empleado", empleadoOpt);
        return "editarEmpleado";
    }

    @PostMapping("/enviarCambios")
    public String enviarCambios(@RequestParam String dni, @RequestParam String nombre, @RequestParam String sexo,
                                @RequestParam Integer categoria, @RequestParam Integer anyos, Model model) {
        empleadoService.modificarEmpleado(dni, nombre, sexo, categoria, anyos);
        model.addAttribute("exito", true);
        return mostrarEmpleados(model);
    }

    @GetMapping("/error")
    public String error(@RequestParam String mensaje, Model model) {
        model.addAttribute("mensaje", mensaje);
        return "error"; // Vista genérica de error
    }
}
