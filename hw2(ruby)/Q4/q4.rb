module Context
  NONE, LIST, PARAGRAPH = 0,1,2
end

# actually we need to maintain a stack of contexts, and pop off
# on completion

class BasicOutputter
  def initialize filename
    @line=nil
    @para_beginning = true
    @list_beginning = true
    @bold_beginning = true
    @emphasis_beginning=true
    @filename=filename
    @context=Context::NONE
  end
  def bold
  end
  def emphasis
  end
  def list
  end
  def paragraph
  end
  def heading
  end
  def reset_context
  end
  def process
  end
  def parse
  end
end

class HTMLOutputter < BasicOutputter
  def bold
  end

  def emphasis
  end

  def list
    printf "<li> %s </li>", @line[2..-1]
  end
  
  def heading
    level = 0
    i     = 0
    while @line[i]=='#'
      level = level+1
      i = i+1
    end
    printf "<h%d>%s</h%d>\n", level,@line[i..-2],level
  end
  
  def reset_context
    case @context
    when Context::LIST
      puts "</ul>"
    when Context::PARAGRAPH
      puts "</p>"
      @para_beginning = true 
    end
  end

  def process
    @line.each_char do |c|
      case c
      when '*'
        if @bold_beginning
          printf "<b>"
          @bold_beginning = false
        else
          printf "</b>"
        end
      when '/'
        if @emphasis_beginning
          printf "<em>"
          @emphasis_beginning = false
        else
          printf "</em>"
        end
      else
        putc c
      end
    end
  end
  
  def paragraph
    process 
  end

  def heading
    level = 0
    i     = 0
    while @line[i]=='#'
      level = level+1
      i = i+1
    end
    
    printf "<h%d>%s</h%d>\n", level,@line[i..-2],level
  end


  def parse
    File.readlines(@filename).each do |text_line|
      if text_line.strip.empty?
        reset_context
        @context = Context::NONE
        next
      end
      @line = text_line
      case @line[0]
      when '#'
        heading 
      when '+'
        if @list_beginning == true
          puts "<ul>"
          @list_beginning = false
        end
        list
        @context = Context::LIST
      else 
        if @para_beginning == true
          puts "<p>"
          @para_beginning = false
        end          
        paragraph
        @context = Context::PARAGRAPH
      end
    end
  end
end

class LatexOutputter < BasicOutputter

  # initializing differently for the latex document
  def initialize filename
    @line=nil
    @para_beginning = true
    @list_beginning = true
    @bold_beginning = true
    @emphasis_beginning=true
    @filename=filename
    @context=Context::NONE

    #printing basic required class and packages needed
    printf "\\documentclass[11pt]{article}\n"
    printf "\\usepackage[margin 1in]{geometry}\n"
    printf "\\begin{document}\n"
  end

  def bold
  end

  def emphasis
  end

  def list 
    printf "\\item %s ", @line[2..-1] #items of list
  end
  
  def heading
    level = 0 #heading level 
    i     = 0
    while @line[i]=='#'
      level = level+1
      i = i+1
    end

    #accordingly deciding the heading
    if level==1
      printf "\\section* {%s}\n", @line[i..-2] 
    elsif level==2
      printf "\\subsection* {%s}\n", @line[i..-2]
    else
      printf "\\subsubsection* {%s}\n", @line[i..-2]
    end

  end
  
  # to reset context everytime
  def reset_context
    case @context
    when Context::LIST
      puts "\\end{itemize}"
    when Context::PARAGRAPH
      puts ""
      @para_beginning = true 
    end
  end

  #for paragraph
  def process
    @line.each_char do |c|
      case c
      when '*'
        if @bold_beginning
          printf "\\textbf{"
          @bold_beginning = false
        else
          printf "}"
        end
      when '/'
        if @emphasis_beginning
          printf "\\emph{"
          @emphasis_beginning = false
        else
          printf "}"
        end
      else
        putc c
      end
    end
  end
  
  def paragraph
    process 
  end

  #parsing through the markdownfile
  def parse
    File.readlines(@filename).each do |text_line|
      if text_line.strip.empty?
        reset_context
        @context = Context::NONE
        next
      end
      @line = text_line
      case @line[0]
      when '#'
        reset_context
        heading 
      when '+'
        if @list_beginning == true
          puts "\\begin{itemize}"
          @list_beginning = false
        end
        list
        @context = Context::LIST
      else 
        reset_context
        if @para_beginning == true
          puts ""
          @para_beginning = false
        end          
        paragraph
        @context = Context::PARAGRAPH
      end
    end
    printf "\\end{document}\n"
  end
end


o = LatexOutputter.new "sample.md"
o.parse
