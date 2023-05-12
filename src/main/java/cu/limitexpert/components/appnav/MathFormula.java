package cu.limitexpert.components.appnav;

import com.vaadin.flow.component.Tag;
import com.vaadin.flow.component.dependency.JsModule;
import com.vaadin.flow.component.littemplate.LitTemplate;

@Tag("math-formula")
@JsModule("./MathFormula.ts")
public class MathFormula extends LitTemplate {

    public void setFormula(String formula) {
        getElement().setProperty("formula", formula);
    }

    public String getFormula() {
        return getElement().getProperty("formula");
    }

}
