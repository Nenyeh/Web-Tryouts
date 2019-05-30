def setup_picture
  if params[:picture].present?
    tempfile = Tempfile.new('blah')
    tempfile.binmode
    tempfile.write(Base64.decode64(params[:picture]))
    uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile)
    params[:picture] = uploaded_file
    params[:picture].rewind
  end
end




api :PUT, '/individuals/:id', 'Update an individual'
param :id, String, required: true, desc: 'Individuals ID'
param :picture, ActionDispatch::Http::UploadedFile, required: false,  desc: 'base64 encoded picture (can be blank but you must have the attribute when submitting request)'
def update
  @individual = Individual.find(params[:id])
  end
  if params[:picture].present?
    if @individual.picture(params[:picture].read)
      render json: @individual, include: @included_relationships, fields: @fieldset
    else
      unprocessable("Could not update picture for #{@individual.preferred_full_name}")
    end
  end
end




def picture
  individual = Individual.find(params[:id])
  send_data(individual.picturefield, disposition: 'inline', content_type: 'image/jpeg')
end
