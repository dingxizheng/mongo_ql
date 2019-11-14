# frozen_string_literal: true

require "date"
require "logger"
module MongoQL
  class MongoQLError < RuntimeError; end
  class InvalidVariableAccess < MongoQLError; end
  class InvalidValueExpression < MongoQLError; end

  EXPRESSION_TO_AST_MAPPER = proc do |v|
    case v
    when Expression, Stage, StageContext
      v.to_ast
    else
      v
    end
  end

  def self.compose(*variable_names, &block)
    block_binding = block.binding
    ctx = MongoQL::StageContext.new

    variables = variable_names.map do |name|
      [name, block_binding.local_variable_get(name)]
    end.to_h

    # Update injected local variables to ValueNode expressions
    variable_names.each do |name|
      ctx.injected_vars[name] = Expression::ValueNode.new(variables[name])
      block_binding.local_variable_set(name, ctx.injected_vars[name])
    end

    ctx.instance_exec(*variables, &block)
    ctx
  ensure
    # Restore local variables
    variable_names.each do |name|
      block_binding.local_variable_set(name, variables[name])
    end
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end
end

require_relative "mongo_ql/version"
require_relative "mongo_ql/utils"
require_relative "mongo_ql/expression"
require_relative "mongo_ql/expression/date_note"
require_relative "mongo_ql/expression/field_node"
require_relative "mongo_ql/expression/value_node"
require_relative "mongo_ql/expression/method_call"
require_relative "mongo_ql/expression/binary"
require_relative "mongo_ql/expression/unary"
require_relative "mongo_ql/expression/condition"
require_relative "mongo_ql/expression/switch"

require_relative "mongo_ql/expression/descend"
require_relative "mongo_ql/expression/ascend"
require_relative "mongo_ql/expression/projection"

require_relative "mongo_ql/stage"
require_relative "mongo_ql/stage/project"
require_relative "mongo_ql/stage/lookup"
require_relative "mongo_ql/stage/match"
require_relative "mongo_ql/stage/group"
require_relative "mongo_ql/stage/unwind"
require_relative "mongo_ql/stage/sort"
require_relative "mongo_ql/stage/add_fields"

require_relative "mongo_ql/stage_context"
