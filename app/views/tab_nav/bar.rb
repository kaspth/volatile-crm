class TabNav::Bar < ActionView::Partial
  slot :extra
  def render(&) = super("tab_nav/bar", tabs: capture(&), extra:)

  def link_tab(text, link, icon:, selected: view.current_page?(link), counter: nil, threshold: nil)
    Tab.new(text:, icon:, selected:).partial __method__, link:, counter: (Counter.new(counter, threshold) if counter)
  end

  def disabled_tab(text, icon:, tooltip:)
    Tab.new(text:, icon:, disabled: true).partial __method__, tooltip:
  end

  def dropdown_tab(text, icon:, selected: false, &)
    Tab.new(text:, icon:, selected:).partial __method__, items: Dropdown.capture(&)
  end

  private
    class Tab < Data.define(:text, :icon)
      include ActionView::Element

      def initialize(text:, icon: nil, **) = super

      def partial(key, **) = render("tab_nav/#{key}", tab: self, **)

      def classes = class_names(
        "group whitespace-nowrap flex items-center space-x-1 rounded rounded-b-none leading-none py-3 px-3 border",
        "border-gray-300 border-b-gray-400 hover:bg-gray-50":   enabled?,
        "border-gray-200 border-b-gray-400 cursor-not-allowed": disabled?,
        "border-b-2 border-b-red-400": selected?
      )

      def icon
        super&.then { view.icons.render(_1, disabled:) }
      end

      def text(**)
        tag.span(super(), class: ["text-gray-500 group-hover:text-gray-600", "font-semibold": selected?], **)
      end
    end

    class Counter < Data.define(:counter, :threshold)
      def to_s
        ActionView.tag.span counter, class: ["text-xs leading-none p-1 rounded bg-gray-200 text-gray-600", threshold_classes]
      end

      private
        def threshold_classes = exceeded? ? "bg-red-200 text-red-600" : "bg-gray-200 text-gray-600"
        def exceeded? = threshold && counter > threshold
    end

    class Dropdown < ActionView::Partial
      def item(text, link)
        link_to text, link, class: "block w-full text-left py-1.5 px-3 text-gray-500 hover:text-gray-600 hover:bg-gray-50"
      end
    end
end
