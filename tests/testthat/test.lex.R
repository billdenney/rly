#! /usr/bin/env Rscript

library(testthat)
library(rly)

context("basic lex")

CalcLexer <- R6::R6Class("CalcLexer",
  public = list(
    tokens = c('NAME','NUMBER'),
    literals = c('=','+','-','*','/', '(',')'),
    t_NAME = '[a-zA-Z_][a-zA-Z0-9_]*',
    t_NUMBER = function(re = '\\d+', t) {
      t$value = strtoi(t$value)
      return(t)
    },
    t_ignore = " \t",
    t_newline = function(re = '\n+', t) {
      t$lexer$lineno = t$lexer$lineno + t$value$count("\n")
      return(NULL)
    },
    t_error = function(t) {
      cat(sprintf("Illegal character '%s'", t$value[0]))
      t$lexer$skip(1)
    }
  )
)

test_that("lex: basic calculator", {
  lexer <- rly::lex(CalcLexer)
  lexer$input("5 + 3")
  expect_equal(lexer$token()$value, 5)
  expect_equal(lexer$token()$value, "+")
  expect_equal(lexer$token()$value, 3)
})
