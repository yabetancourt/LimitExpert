package cu.limitexpert.views;

import com.vaadin.flow.component.Key;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.confirmdialog.ConfirmDialog;
import com.vaadin.flow.component.formlayout.FormLayout;
import com.vaadin.flow.component.html.Image;
import com.vaadin.flow.component.html.Span;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.data.value.ValueChangeMode;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.router.RouteAlias;
import com.vaadin.flow.theme.lumo.LumoUtility;
import cu.limitexpert.components.MathFormula;
import cu.limitexpert.utils.Step;
import org.jpl7.PrologException;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static cu.limitexpert.utils.PrologUtils.limite;
import static cu.limitexpert.utils.PrologUtils.limitePasos;

@PageTitle("Calculadora de límites")
@Route(value = "limit", layout = MainLayout.class)
@RouteAlias(value = "", layout = MainLayout.class)
public class LimitView extends VerticalLayout {

    private final TextField functionField;
    private final TextField limitField;
    private final VerticalLayout stepContainer;

    public LimitView() {
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
        functionField.setClearButtonVisible(true);
        functionField.setPlaceholder("Introduzca la función");
        functionField.setValueChangeMode(ValueChangeMode.TIMEOUT);

        limitField = new TextField("Valor al que tiende x:");
        limitField.setWidthFull();
        limitField.setRequired(true);
        limitField.setErrorMessage("Por favor llene este campo.");
        limitField.setValueChangeMode(ValueChangeMode.TIMEOUT);

        // Agregar listeners a los campos de entrada
        functionField.addValueChangeListener(valueChange -> {
            formula.setFormula(getExpression(limitField.getValue(), functionField.getValue()));
            expression.setVisible(!Objects.equals(functionField.getValue(), "") || limitField.getValue() != null);
        });

        limitField.addValueChangeListener(value -> {
            formula.setFormula(getExpression(limitField.getValue(), functionField.getValue()));
            expression.setVisible(!Objects.equals(functionField.getValue(), "") || limitField.getValue() != null);
        });

        // Crear el botón de cálculo
        Button calculateButton = new Button("Calcular");
        calculateButton.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        calculateButton.addClickShortcut(Key.ENTER);

        // Agregar los componentes al formulario
        formLayout.add(functionField, 4);
        formLayout.add(limitField, 1);
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
            if (functionField.isEmpty() || limitField.isEmpty()) {
                functionField.setInvalid(functionField.isEmpty());
                limitField.setInvalid(limitField.isEmpty());
                return;
            }

            // Obtener la función y el límite ingresados por el usuario
            String function = functionField.getValue();
            String limit = limitField.getValue();

            // Calcular los pasos del límite utilizando Prolog
            List<Step> steps = calculateLimitSteps(function, limit);
            stepContainer.removeAll();
            Span procedure = new Span("Procedimiento: ");
            procedure.addClassNames(LumoUtility.TextColor.TERTIARY);
            stepContainer.add(procedure);
            // Agregar cada paso como un elemento de texto separado
            for (Step step : steps) {
                stepContainer.add(step.getDescription(), step.getFormula());
            }

        });
    }

    // Método para calcular los pasos del límite
    private List<Step> calculateLimitSteps(String function, String limit) {
        List<Step> steps = new ArrayList<>();
        try {
            List<List<String>> pasos = limitePasos(function, limit);
            for (List<String> list : pasos) {
                steps.add(new Step(list.get(0), list.get(1)));
            }
            steps.add(new Step("Solución:", limite(function, limit)));
            return steps;
        } catch (PrologException exception) {
            ConfirmDialog dialog = new ConfirmDialog();
            dialog.setHeader("Error");
            dialog.setConfirmText("Aceptar");
            dialog.setCancelable(false);
            dialog.setText(exception.getMessage());
            dialog.open();
        }

        return steps;
    }

    // Método para establecer la expresión del límite
    private String getExpression(String toLimit, String function) {
        if (toLimit.isBlank())
            toLimit = "?";

        if (function == null)
            function = "";

        return String.format("lim_{x \\to %s} %s", toLimit, function);
    }

}