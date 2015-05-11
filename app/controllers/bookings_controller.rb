# Copyright (c) 2012 Red (E) Tools Ltd.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class BookingsController < ApplicationController

  def show
    respond_to do |wants|
      wants.js {
        @booking = get_model
        render 'go_to_booking_form'
      }
      wants.html {
        if params[:id] != 'last'
          @booking = @current_vendor.bookings.existing.find_by_id(params[:id])
        else
          @booking = @current_vendor.bookings.existing.find_all_by_finished(true).last
        end
        redirect_to '/' and return if not @booking
        if @booking.finished
          @previous_booking, @next_booking = neighbour_models('bookings', @booking)
        end
      }
    end
  end

  def by_nr
    @booking = @current_vendor.bookings.existing.find_by_nr(params[:nr])
    if @booking
      redirect_to booking_path(@booking)
    else
      redirect_to booking_path(@current_vendor.bookings.existing.last)
    end
  end

end