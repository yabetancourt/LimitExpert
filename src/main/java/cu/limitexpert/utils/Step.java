package cu.limitexpert.utils;

import com.vaadin.flow.component.html.Paragraph;
import cu.limitexpert.components.MathFormula;

public class Step {

    private final Paragraph description;

    private final MathFormula formula;

    private Paragraph implication;

    public Step(String description, String formula) {
        this.description = new Paragraph(description);
        this.formula = new MathFormula(formula);
        if (description.contains("Regla de la cadena")){
            implication = new Paragraph("Sabiendo que: ");
        }
    }

    public MathFormula getFormula() {
        return formula;
    }

    public Paragraph getDescription() {
        return description;
    }

    public Paragraph getImplication() {
        return implication;
    }
}
