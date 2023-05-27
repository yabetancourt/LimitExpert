package cu.limitexpert.utils;

import com.vaadin.flow.component.html.Paragraph;
import cu.limitexpert.components.MathFormula;

public class Step {

    private final Paragraph description;

    private final MathFormula formula;

    public Step(String description, String formula) {
        this.description = new Paragraph(description);
        this.formula = new MathFormula(formula);
    }

    public MathFormula getFormula() {
        return formula;
    }

    public Paragraph getDescription() {
        return description;
    }
}
