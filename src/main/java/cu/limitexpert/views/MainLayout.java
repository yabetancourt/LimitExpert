package cu.limitexpert.views;


import com.vaadin.flow.component.UI;
import com.vaadin.flow.component.applayout.AppLayout;
import com.vaadin.flow.component.applayout.DrawerToggle;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.html.Footer;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.html.H2;
import com.vaadin.flow.component.html.Header;
import com.vaadin.flow.component.icon.VaadinIcon;
import com.vaadin.flow.component.orderedlayout.Scroller;
import com.vaadin.flow.dom.ThemeList;
import com.vaadin.flow.router.PageTitle;
import com.vaadin.flow.theme.lumo.Lumo;
import com.vaadin.flow.theme.lumo.LumoUtility;
import cu.limitexpert.components.AppNav;
import cu.limitexpert.components.AppNavItem;
import org.vaadin.lineawesome.LineAwesomeIcon;

/**
 * The main view is a top-level placeholder for other views.
 */
public class MainLayout extends AppLayout {

    private H2 viewTitle;

    public MainLayout() {
        setPrimarySection(Section.DRAWER);
        addDrawerContent();
        addHeaderContent();
    }

    private void addHeaderContent() {
        DrawerToggle toggle = new DrawerToggle();
        toggle.getElement().setAttribute("aria-label", "Menu toggle");

        viewTitle = new H2();
        viewTitle.addClassNames(LumoUtility.FontSize.LARGE, LumoUtility.Margin.NONE);
        Button toggleButton = new Button(VaadinIcon.MOON_O.create());
        toggleButton.addClickListener(click -> {
                ThemeList themeList = UI.getCurrent().getElement().getThemeList();

                if (themeList.contains(Lumo.DARK)) {
                    themeList.remove(Lumo.DARK);
                    toggleButton.setIcon(VaadinIcon.MOON_O.create());
                } else {
                    themeList.add(Lumo.DARK);
                    toggleButton.setIcon(LineAwesomeIcon.SUN.create());
                }
        });
        toggleButton.addClassNames(LumoUtility.Margin.Left.AUTO, LumoUtility.Padding.Right.LARGE);
        toggleButton.addThemeVariants(ButtonVariant.LUMO_TERTIARY_INLINE);
        addToNavbar(true, toggle, viewTitle, toggleButton);
    }

    private void addDrawerContent() {
        H1 appName = new H1("Experto en Límites");
        appName.addClassNames(LumoUtility.FontSize.LARGE, LumoUtility.Margin.NONE);
        Header header = new Header(appName);

        Scroller scroller = new Scroller(createNavigation());

        addToDrawer(header, scroller, createFooter());
    }

    private AppNav createNavigation() {
        // AppNav is not yet an official component.
        // For documentation, visit https://github.com/vaadin/vcf-nav#readme
        AppNav nav = new AppNav();

        nav.addItem(new AppNavItem("Calcular Límites", LimitView.class, LineAwesomeIcon.ARROW_RIGHT_SOLID.create()));
        nav.addItem(new AppNavItem("Calcular Derivadas", DerivativeView.class, LineAwesomeIcon.WAVE_SQUARE_SOLID.create()));
        nav.addItem(new AppNavItem("Ayuda", HelpView.class, LineAwesomeIcon.QUESTION_SOLID.create()));
        return nav;
    }

    private Footer createFooter() {
        return new Footer();
    }

    @Override
    protected void afterNavigation() {
        super.afterNavigation();
        viewTitle.setText(getCurrentPageTitle());
    }

    private String getCurrentPageTitle() {
        PageTitle title = getContent().getClass().getAnnotation(PageTitle.class);
        return title == null ? "" : title.value();
    }
}
