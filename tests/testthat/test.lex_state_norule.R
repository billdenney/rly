#! /usr/bin/env Rscript

library(testthat)
library(rly)

context("Declaration of a state for which no rules are defined")

Lexer <- R6::R6Class("Lexer",
  public = list(
    tokens = c('NUMBER', 'PLUS','MINUS'),
    states = list(c('comment', 'exclusive'),
                  c('example', 'exclusive')),
    t_PLUS = '\\+',
    t_MINUS = '-',
    t_NUMBER = '\\d+',
    t_comment = function(re='/\\*', t) {
      t$lexer$begin('comment')
    },
    t_comment_body_part = function(re='(.|\\n)*\\*/',  t) {
      t$lexer$begin('INITIAL')
    },
    t_error = function(t) { }
  )
)

test_that("no rule at all for state", {
  expect_output(expect_error(rly::lex(Lexer), "Can't build lexer"),
  "ERROR .* No rules defined for state 'example'")
})
