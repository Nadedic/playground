module Renderer
  extend self

  def render_catalog(catalog)
    context = make_context catalog: catalog

    render_view 'layout', context do
      render_view 'catalog', context
    end
  end

  def render_exercise(exercise)
    exercise_markdown = File.read SOLUTION_ROOT.join(exercise.markdown_file)
    context           = make_context exercise: exercise, base: '../../'

    render_view 'layout', context do
      render_view 'exercise', context do
        markdown.render exercise_markdown
      end
    end
  end

  def render_problem(problem)
    problem_markdown = File.read SOLUTION_ROOT.join(problem.markdown_file)
    context          = make_context problem: problem, base: '../../'

    render_view 'layout', context do
      render_view 'problem', context do
        markdown.render problem_markdown
      end
    end
  end

  private

  def render_view(name, context, &block)
    filename = VIEWS_ROOT.join("#{name}.erb").to_s
    Tilt::ERBTemplate.new(filename).render(context, &block)
  end

  def make_context(hash = {})
    Object.new.tap do |context|
      hash.each do |key, value|
        context.instance_variable_set :"@#{key}", value
      end
    end
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new Markdown, tables: true
  end

  class Markdown < Redcarpet::Render::HTML
    def postprocess(html)
      doc = Nokogiri::HTML(html)
      doc.search('table').each do |node|
        node[:class] = 'table table-bordered table-striped table-compact'
      end
      doc.to_s
    end
  end
end
