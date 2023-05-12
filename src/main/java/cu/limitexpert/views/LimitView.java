package cu.limitexpert.views;

import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.html.Paragraph;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.NumberField;
import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.data.value.ValueChangeMode;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.router.RouteAlias;
import cu.limitexpert.components.appnav.MathFormula;

import java.util.ArrayList;
import java.util.List;

@PageTitle("Calculadora de límites")
@Route(value = "limit", layout = MainLayout.class)
@RouteAlias(value = "", layout = MainLayout.class)
public class LimitView extends VerticalLayout {

    private final TextField functionField;
    private final NumberField limitField;
    private final VerticalLayout stepContainer;

    public LimitView() {
        // Crear el formulario
        FormLayout formLayout = new FormLayout();
        formLayout.setResponsiveSteps(new FormLayout.ResponsiveStep("0", 1),
                new FormLayout.ResponsiveStep("400px", 6));
        formLayout.setWidthFull();

        MathFormula formula = new MathFormula();

        // Crear los campos de entrada
        functionField = new TextField("Función:");
        functionField.setWidthFull();
        functionField.setRequired(true);
        functionField.setValueChangeMode(ValueChangeMode.TIMEOUT);
        functionField.addValueChangeListener(valueChange -> formula.setFormula(functionField.getValue()));
        limitField = new NumberField("Valor al que tiende x:");
        limitField.setWidthFull();
        limitField.setRequired(true);

        // Crear el botón de cálculo
        Button calculateButton = new Button("Calcular");
        calculateButton.addThemeVariants(ButtonVariant.LUMO_PRIMARY);

        // Agregar los componentes al formulario
        formLayout.add(functionField, 4);
        formLayout.add(limitField, 1);
        formLayout.add(calculateButton, 1);

        // Crear el contenedor de los pasos
        stepContainer = new VerticalLayout();
        stepContainer.setWidth("100%");
        stepContainer.setMinHeight("400px");
        stepContainer.setVisible(false); // Ocultar el contenedor al inicio

        // Agregar el contenedor a la vista
        add(formLayout);
        add(formula);
        add(stepContainer);

        // Configuración del botón de cálculo
        calculateButton.addClickListener(event -> {
            // Validar los campos de entrada
            if (functionField.isEmpty() || limitField.isEmpty()) {
                functionField.setInvalid(functionField.isEmpty());
                limitField.setInvalid(limitField.isEmpty());
                return;
            }

            // Obtener la función y el límite ingresados por el usuario
            String function = functionField.getValue();
            double limit = limitField.getValue();

            // Calcular los pasos del límite utilizando Prolog
            List<String> steps = calculateLimitSteps(function, limit);

            // Agregar cada paso como un elemento de texto separado
            for (String step : steps) {
                stepContainer.add(new Paragraph(step));
            }

            // Mostrar los pasos en el contenedor
            stepContainer.setVisible(true);
        });
    }

    private List<String> calculateLimitSteps(String function, double limit) {
        // Aquí iría el código para calcular los pasos del límite utilizando Prolog
        // Por ahora, simplemente devolvemos una lista de pasos de ejemplo
        List<String> steps = new ArrayList<>();
        steps.add("Paso 1 ...");
        steps.add("Paso 2 ...");
        steps.add("Paso 3 ...");
        steps.add("Paso 4 ...");
        return steps;
    }

}