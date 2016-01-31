module WebApiRenderer

  extend ActiveSupport::Concern

  CODE_SUCCESS = 'success'.freeze
  CODE_FAILURE = 'failure'.freeze

  CODE_FAILURE_NOT_FOUND       = 'failure-not-found'.freeze
  CODE_FAILURE_WRONG_PARAMETER = 'failure-wrong-parameter'.freeze
  CODE_FAILURE_WRONG_STATE     = 'failure-wrong-state'.freeze

  self.included do |includer|

    # 200
    def render_ok(collection, size = collection.size, message = nil)
      result = {
        meta:       meta,
        success:    true,
        code:       self.class::CODE_SUCCESS,
        message:    message||'成功。',
        collection: collection,
        size:       size
      }
      respond_result :ok, result
    end

    # 201
    def render_created(collection, size = collection.size, message = nil)
      result = {
        meta:       meta,
        success:    true,
        code:       self.class::CODE_SUCCESS,
        message:    message||'创建成功。',
        collection: collection,
        size:       size
      }
      respond_result :created, result
    end

    # 400
    def render_bad_request(errors, code = nil, message = nil, collection = [], size = 0)
      result = {
        meta:       meta,
        success:    false,
        code:       code||self.class::CODE_FAILURE_WRONG_PARAMETER,
        message:    message||'参数出错。',
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :bad_request, result
    end

    # 400 bad request - blank parameter
    def render_blank_parameter(parameter_name)
      result = {
        meta:       meta,
        success:    false,
        code:       self.class::CODE_FAILURE_WRONG_PARAMETER,
        message:    "#{parameter_name}参数不能为空。",
        collection: [],
        size:       0,
        errors:     { parameter_name => [ '不能为空' ] }
      }
      respond_result :bad_request, result
    end

    # 404
    def render_not_found(errors, message = nil, collection = [], size = 0)
      result = {
        meta:       meta,
        success:    false,
        code:       self.class::CODE_FAILURE_NOT_FOUND,
        message:    message||'没有找到符合条件的信息。',
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :not_found, result
    end

    # 404 not found - inexistent
    def render_inexistent(parameter_name, message)
      result = {
        meta:       meta,
        success:    false,
        code:       self.class::CODE_FAILURE_NOT_FOUND,
        message:    message,
        collection: [],
        size:       0,
        errors:     { parameter_name => [ '不存在' ] }
      }
      respond_result :not_found, result
    end

    # 409
    def render_conflict(errors, message, collection = [], size = 0)
      result = {
        meta:       meta,
        success:    false,
        code:       self.class::CODE_FAILURE_WRONG_STATE,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :conflict, result
    end

    # 409 conflict - wrong parameter
    def render_wrong_parameter(errors, message, collection = [], size = 0)
      result = {
        meta:       meta,
        success:    false,
        code:       self.class::CODE_FAILURE_WRONG_PARAMETER,
        message:    message,
        collection: collection,
        size:       size,
        errors:     errors
      }
      respond_result :conflict, result
    end

    def respond_result(status, result)
      respond_to do |format|
        format.json do render status: status, json: result end
        format.xml  do render status: status, xml:  result end
      end
    end

    private :respond_result

  end

end
