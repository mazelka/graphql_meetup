# frozen_string_literal: true

module List::Operation
  class RemoveItem < Trailblazer::Operation
    step :init_model
    step :item_added?
    fail :item_not_added

    step Rescue(ActiveRecord::RecordInvalid, handler: :error_handler) {
      step :remove_item!
    }

    step :set_result

    def init_model(ctx, params:, **)
      ctx[:model] = ListsMovie.find_by(list_id: params[:list_id], movie_id: params[:movie_id])
    end

    def item_added?(_ctx, model:, **)
      model.present?
    end

    def remove_item!(_ctx, model:, **)
      model.destroy!
    end

    def item_not_added(ctx, **)
      ctx['operation_status'] = :bad_request
      ctx['operation_message'] = I18n.t('graphql.errors.messages.movie.item_not_added')
    end

    def set_result(ctx, params:, **)
      ctx['result'] = { removed_movie_id: params[:movie_id] }
    end

    private

    def error_handler(exception, ctx)
      ctx['operation_status'] = :execution_error

      raise ActiveRecord::Rollback, exception.message
    end
  end
end
