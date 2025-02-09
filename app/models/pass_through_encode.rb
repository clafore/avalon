# Copyright 2011-2022, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

class PassThroughEncode < WatchedEncode
  self.engine_adapter = :pass_through

  before_create prepend: true do |encode|
    localize_input encode
  end

  private

    # Download s3 object to extract technical metadata locally
    def localize_input(encode)
      return unless Addressable::URI.parse(encode.input.url).scheme == 's3'
      encode.input.url = localize_s3_file encode.input.url
      encode.options[:outputs].each do |output|
        output[:url] = localize_s3_file output[:url]
      end
    end
end
