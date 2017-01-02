var gulp = require('gulp');
var elm = require('gulp-elm');
var plumber = require('gulp-plumber');
var del = require('del');
var minify = require('gulp-minify');
var rename = require("gulp-rename");
var gutil = require("gulp-util");
var browserSync    = require('browser-sync').create()

// builds elm files and static resources (i.e. html and css) from src to dist folder
var paths = {
  dest: './dist',
  dest_assets: './dist/assets',
  elm: './src/*.elm',
  main_elm: './src/Main.elm',
  index: './assets/index.html',
  staticAssets: './assets/*.{png,js,jpg,css,webm}'
};

gulp.task('clean', function(cb) {
  del([paths.dest], cb);
});

gulp.task('elm-init', elm.init);

gulp.task('elm', ['elm-init'], function() {
  return gulp.src(paths.elm)
    .pipe(plumber())
    .pipe(elm())
    .pipe(elm.bundle("elm.js"))
    .pipe(gulp.dest(paths.dest));
});

gulp.task('index', function() {
  return gulp.src(paths.index)
    .pipe(plumber())
    .pipe(gulp.dest(paths.dest));
});

gulp.task('staticAssets', function() {
  return gulp.src(paths.staticAssets)
    .pipe(plumber())
    .pipe(gulp.dest(paths.dest_assets));
});

gulp.task('elm-watch', ['elm-bundle'], function (cb) {
    browserSync.reload();
    cb();
});

gulp.task('watch', function() {
  browserSync.init({
    server: {
      baseDir: "./dist"
    }
  });
  console.log("Listening on port 3000");

  gulp.watch(paths.elm, ['elm-watch']);
  gulp.watch(paths.index, ['index']);
  gulp.watch(paths.staticAssets, ['elm-bundle', 'staticAssets']);

});

gulp.task('elm-bundle', ['elm-init'], function(){
  return gulp.src(paths.main_elm)
    .pipe(elm.bundle('elm.js').on('error', gutil.log))
    .pipe(gulp.dest(paths.dest_assets));

});

gulp.task('build', ['elm-bundle', 'staticAssets', 'index']);
gulp.task('dev', ['build', 'watch']);
gulp.task('default', ['dev']);
