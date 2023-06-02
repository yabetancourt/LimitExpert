package cu.limitexpert.views;

import com.vaadin.flow.component.accordion.Accordion;
import com.vaadin.flow.component.accordion.AccordionPanel;
import com.vaadin.flow.component.html.*;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.theme.lumo.LumoUtility;
import cu.limitexpert.components.MathFormula;

import static cu.limitexpert.utils.PrologUtils.getDerivationRules;

@PageTitle("Ayuda")
@Route(value = "help", layout = MainLayout.class)
public class HelpView extends VerticalLayout {

    public HelpView() {
        Image image = new Image("../themes/expertoenlmites/images/questions.svg", "preguntas");
        image.addClassNames("help-image");
        // Agrega un texto explicativo sobre cómo usar el software y cómo ingresar los datos en MathAscii
        H2 intro = new H2("Bienvenido a la sección de ayuda");

        // sección sobre MathAscii
        Span mathAscii = new Span(" Aquí encontrarás información detallada sobre cómo usar el software y cómo ingresar los datos en MathAscii.\n" +
                "MathAscii es un lenguaje de notación matemática que se utiliza para ingresar fórmulas y expresiones matemáticas en el software.");
        mathAscii.addClassNames(LumoUtility.FontSize.LARGE);
        VerticalLayout introDiv = new VerticalLayout(intro, mathAscii);
        HorizontalLayout header = new HorizontalLayout(introDiv, image);
        header.setWidthFull();
        add(header);

        // sección sobre funciones
        Accordion accordion = new Accordion();
        accordion.setWidthFull();

        AccordionPanel rulesPanel = new AccordionPanel(new H3("Reglas de Derivación"));
        for (String s : getDerivationRules())
            rulesPanel.addContent(new Paragraph(s));
        accordion.add(rulesPanel);


        MathFormula polyExample = new MathFormula("f(x) = a_n x^n + a_{n-1} x^{n-1} + ... + a_1 x + a_0");
        Paragraph polyDescription = new Paragraph("Un polinomio es una expresión matemática que consta de una suma de términos, cada uno de los cuales es el producto de una constante y una variable elevada a una potencia entera no negativa.");
        H4 polyAscii = new H4("Algunas funciones polinómicas en MathAscii:");
        Paragraph poly1 = new Paragraph("f(x) = x^n + 2*x^(n-1) + 1");
        Paragraph poly2 = new Paragraph("g(x) = 3 * x^3 - 2*x^2 + 5*x - 1");
        AccordionPanel polyPanel = new AccordionPanel(new H3("Polinomios"), polyExample, polyDescription, polyAscii, poly1, poly2);
        accordion.add(polyPanel);

        MathFormula trigExample = new MathFormula("sin(x) ^ 2 + cos(x) ^ 2 = 1");
        Paragraph trigDescription = new Paragraph("Las funciones trigonométricas son un conjunto de funciones matemáticas que se utilizan para calcular ángulos y longitudes en triángulos. Las funciones trigonométricas más comunes son el seno, el coseno, la tangente, la cotangente, la cosecante y la secante.");
        H4 trigAscii = new H4("algunas funciones trigonométricas comunes en MathAscii: ");
        Paragraph sin = new Paragraph("sin(x) - Calcula el seno de x");
        Paragraph cos = new Paragraph("cos(x) - Calcula el coseno de x");
        Paragraph tan = new Paragraph("tan(x) - Calcula la tangente de x");
        Paragraph cot = new Paragraph("cot(x) - Calcula la cotangente de x");
        Paragraph csc = new Paragraph("csc(x) - Calcula la cosecante de x");
        Paragraph sec = new Paragraph("sec(x) - Calcula la secante de x");
        AccordionPanel trigPanel = new AccordionPanel(new H3("Funciones Trigonométricas"),  trigExample, trigDescription, trigAscii, sin, cos, tan, cot, csc, sec);
        accordion.add(trigPanel);

        MathFormula logExample = new MathFormula("log_b(x) = y");
        Paragraph logDescription = new Paragraph("Un logaritmo es una función matemática que se utiliza para calcular el exponente al que se debe elevar una base para obtener un número determinado.");
        H4 logAscii = new H4("Algunas funciones logarítmicas en MathAscii:");
        Paragraph log1 = new Paragraph("log(x) - Calcula el logaritmo natural de x");
        Paragraph log2 = new Paragraph("log_b(x) - Calcula el logaritmo de x en base b");
        AccordionPanel logPanel = new AccordionPanel(new H3("Logaritmos"), logExample, logDescription, logAscii, log1, log2);
        accordion.add(logPanel);

        MathFormula expExample = new MathFormula("f(x) = a^x");
        Paragraph expDescription = new Paragraph("Una función exponencial es una función matemática que se utiliza para modelar el crecimiento o la disminución exponencial de una cantidad.");
        H4 expAscii = new H4("Algunas funciones exponenciales en MathAscii:");
        Paragraph exp1 = new Paragraph("2^x");
        Paragraph exp2 = new Paragraph("e^x");
        AccordionPanel expPanel = new AccordionPanel(new H3("Funciones Exponenciales"), expExample, expDescription, expAscii, exp1, exp2);
        accordion.add(expPanel);

        accordion.close();
        add(accordion);

    }
}

