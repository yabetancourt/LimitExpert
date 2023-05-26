package cu.limitexpert.views;

import com.vaadin.flow.component.Key;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.html.Image;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.data.value.ValueChangeMode;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.theme.lumo.LumoUtility;
import cu.limitexpert.components.MathFormula;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static cu.limitexpert.utils.PrologUtils.derivar;

@PageTitle("Calculadora de Derivadas")
@Route(value = "derivative", layout = MainLayout.class)
public class DerivativeView extends VerticalLayout {

    private final TextField functionField;
    private final TextField variableField;
    private final VerticalLayout stepContainer;

    public DerivativeView() {
        // Crear el formulario
        FormLayout formLayout = new FormLayout();
        formLayout.setResponsiveSteps(new FormLayout.ResponsiveStep("0", 1),
                new FormLayout.ResponsiveStep("400px", 6));
        formLayout.setWidthFull();

        // Crear los componentes para introducir los datos
        Span expression = new Span("Expresión: ");
        expression.addClassNames(LumoUtility.TextColor.TERTIARY);
        expression.setVisible(false);
        MathFormula formula = new MathFormula();
        VerticalLayout expressionLayout = new VerticalLayout(expression, formula);

        functionField = new TextField("Función:");
        functionField.setWidthFull();
        functionField.setRequired(true);
        functionField.setErrorMessage("Por favor llene este campo.");
        functionField.setPlaceholder("Introduzca la función");
        functionField.setClearButtonVisible(true);
        functionField.setValueChangeMode(ValueChangeMode.TIMEOUT);

        variableField = new TextField("Derivar respecto a: ");
        variableField.setWidthFull();
        variableField.setRequired(true);
        variableField.setErrorMessage("Por favor llene este campo.");
        variableField.setValueChangeMode(ValueChangeMode.TIMEOUT);

        // Agregar listeners a los campos de entrada
        functionField.addValueChangeListener(valueChange -> {
            formula.setFormula(getExpression(variableField.getValue(), functionField.getValue()));
            expression.setVisible(!Objects.equals(functionField.getValue(), "") || variableField.getValue() != null);
        });

        variableField.addValueChangeListener(value -> {
            formula.setFormula(getExpression(variableField.getValue(), functionField.getValue()));
            expression.setVisible(!Objects.equals(functionField.getValue(), "") || variableField.getValue() != null);
        });

        // Crear el botón de cálculo
        Button calculateButton = new Button("Calcular");
        calculateButton.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        calculateButton.addClickShortcut(Key.ENTER);

        // Agregar los componentes al formulario
        formLayout.add(functionField, 4);
        formLayout.add(variableField, 1);
        formLayout.add(calculateButton, 1);

        // Crear el contenedor de los pasos
        stepContainer = new VerticalLayout();
        stepContainer.setWidth("60%");
        stepContainer.setMinHeight("400px");
        // Ocultar el contenedor al inicio
        HorizontalLayout bodyLayout = new HorizontalLayout();
        bodyLayout.setWidthFull();
        Image image = new Image("../themes/expertoenlmites/images/math.svg", "Math");
        image.addClassNames("image");
        bodyLayout.add(stepContainer, image);
        // Agregar el contenedor a la vista
        add(formLayout, expressionLayout, bodyLayout);

        // Configuración del botón de cálculo
        calculateButton.addClickListener(event -> {
            // Validar los campos de entrada
            if (functionField.isEmpty() || variableField.isEmpty()) {
                functionField.setInvalid(functionField.isEmpty());
                variableField.setInvalid(variableField.isEmpty());
                return;
            }

            // Obtener la función y el límite ingresados por el usuario
            String function = functionField.getValue();
            String limit = variableField.getValue();

            // Calcular los pasos del límite utilizando Prolog
            List<String> steps = calculateDerivativeSteps(function, limit);
            stepContainer.removeAll();
            Span procedure = new Span("Procedimiento: ");
            procedure.addClassNames(LumoUtility.TextColor.TERTIARY);
            stepContainer.add(procedure);
            // Agregar cada paso como un elemento de texto separado
            for (String step : steps) {
                stepContainer.add(new MathFormula(step));
            }

        });
    }

    // Método para calcular los pasos del límite
    private List<String> calculateDerivativeSteps(String function, String variable) {
        // Aquí iría el código para calcular los pasos del límite utilizando Prolog
        // Por ahora, simplemente devolvemos una lista de pasos de ejemplo
        List<String> steps = new ArrayList<>();
        steps.add("Paso 1 ...");
        steps.add("Paso 2 ...");
        steps.add("Paso 3 ...");
        steps.add("Paso 4 ...");
        steps.add(derivar(function, variable));
        return steps;
    }

    // Método para establecer la expresión del límite
    private String getExpression(String variable, String function) {
        if (variable.isBlank())
            variable = "?";

        if (function == null)
            function = "";

        return String.format("d/d%s %s", variable, function);
    }


}
