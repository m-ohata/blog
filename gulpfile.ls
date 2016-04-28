require! <[gulp gulp-markdown gulp-debug gulp-util run-sequence colors]>

paths =
  markdown:
    "./posts/*.md"

renderer = new gulp-markdown.marked.Renderer!
  ..heading = (text, level)->
    escaped-text = text.to-lower-case!.replace /[^\w]+/g, "-"
    switch level
    | 3 =>
      """

        <div style="text-align: left; padding: 10px 10px; border-color: \#73bc9b; border-width: 0 0 1px 7px; border-style: solid; background: \#F8F8F8;margin-top: 2em; margin-bottom: 2em;"><h#level style="text-align: left;">#text</h#level></div>

      """
    | 4 =>
      """

        <h#level style="margin-top: 1em; margin-bottom: 1em;">#text</h#level>

      """
    | _ =>
      """

        <h#level>#text</h#level>

      """
  ..link = (href, title, text)->
    """
      <a href="#href" title="#title" rel="nofollow" target="_blank">#text</a>
    """
  ..image = (href, title, text)->
    """
      <img src="#href" alt="#text" class="alignnone size-medium" />
    """

gulp
  ..task \default, ->
    run-sequence do
      \markdown

  ..task \markdown, ->
    options =
      breaks: yes
      renderer: renderer
      pedantic: yes
    gulp
      .src paths.markdown
      .pipe gulp-debug!
      .pipe gulp-markdown options
      .pipe gulp.dest \dist

  ..task \watch, (cb)->
    options = interval: 500
    gulp.watch do
      paths.markdown
      options
      ->
        console.log "Changed Markdown".green
        run-sequence do
          \markdown

