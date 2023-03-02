class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  use Rack::Session::Cookie, :expire_after => 259200000000
  
  # To enable cross origin requests for all routes:
  set :bind, '0.0.0.0'
  configure do
    enable :cross_origin
  end
  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = '*'
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS, PUT, DELETE"
  end
  
  # routes...
  options "*" do
    response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end
  
  # GET projects
  get "/projects" do
    project = Project.all
    project.to_json
  end
  get "/projects/" do
    project = Project.all
    project.to_json
  end
  get "/projects/:id" do
    project = Project.find(params[:id])
    project.to_json(
      only: [
              :title, 
              :color, 
              :created_at, 
              :updated_at]
      )
  end

  # GET tasks
  get "/tasks" do
    task = Task.all
    task.to_json
  end
  get "/tasks/" do
    task = Task.all
    task.to_json
  end
  get "/tasks/:id" do
    task = Task.find(params[:id])
    task.to_json(
      only: [
        :name, 
        :due_date, 
        :description, 
        :status, 
        :priority, 
        :completed, 
        :board_id, 
        :created_at, 
        :updated_at
      ]
    )
  end

  # GET boards
  get "/boards" do
    board = Board.all
    board.to_json
  end
  get "/boards/" do
    board = Board.all
    board.to_json
  end
  get "/boards/:id" do
    task = Task.find(params[:id])
    task.to_json(only: [
      :name, 
      :due_date, 
      :description, 
      :status, 
      :priority, 
      :completed, 
      :board_id, 
      :created_at, 
      :updated_at
    ]
  )
  end

  #POST projects
  post '/projects' do
    project = Project.create(
      title:params[:title], 
      color:params[:color], 
      favorite:params[:favorite]
    )
    project.to_json
  end
  post '/projects/' do
    project = Project.create(
      title:params[:title], 
      color:params[:color], 
      favorite:params[:favorite]
    )
    project.to_json
  end

  #POST tasks
  post '/tasks' do
    task = Task.create(
      name:params[:name], 
      due_date:params[:due_date], 
      description:params[:description], 
      status:params[:params], 
      priority:params[:priority], 
      completed:params[:completed], 
      board_id:params[:board_id]
    )
    task.to_json
  end
  post '/tasks/' do
    task = Task.create(
      name:params[:name], 
      due_date:params[:due_date], 
      description:params[:description], 
      status:params[:params], 
      priority:params[:priority], 
      completed:params[:completed], 
      board_id:params[:board_id]
    )
    task.to_json
  end
  #POST boards
  post '/boards' do
    board = Board.create(
      name:params[:name], 
      project_id:params[:project_id]
    )
    board.to_json
  end
  post '/boards/' do
    board = Board.create(
      name:params[:name], 
      project_id:params[:project_id]
    )
    board.to_json
  end

  # PATCH boards
  patch '/projects/:id' do
    project = Project.find(params[:id])
    project.update(
      title: params[:title],
      color: params[:color],
      favorite: params[:favorite],
    )
  end

  # PATCH tasks
  patch '/tasks/:id' do
    task = Task.find(params[:id])
    task.update(
      name: params[:name],
      project_id: params[:project_id]
    )
  end

  #PATCH boards
  patch '/boards/:id' do
    board = Board.find(params[:id])
    board.update(
      name: params[:name],
      due_date: params[:due_date],
      description: params[:description],
      status: params[:status],
      completed: params[:completed],
      board_id: params[:board_id]
    )
  end

  #DELETE projects
  delete '/projects/:id' do
    project = Project.find(params[:id])
    project.destroy
    project.to_json
  end

  #DELETE tasks
  delete '/tasks/:id' do
    task = Task.find(params[:id])
    task.destroy
    task.to_json
  end

  #DELETE boards
  delete '/boards/:id' do
    board = Board.find(params[:id])
    board.destroy
    board.to_json
  end












  
  # def call(env)
  #   resp = Rack::Response.new
  #   req = Rack::Request.new(env)

  #   # projects get/read 
  # if req.path.match(/projects/) && req.get? #controller interprates the request given from the front-end

  #   #check if requesting all projects or an individual project
  #   if req.path.split("/projects/").length === 1 
  #     # retrieve information from model and send back information to the front-end
  #     return [200, { 'Content-Type' => 'application/json' }, [ {:message => "projects successfully requested", :projects => Project.all}.to_json(:include => :tasks) ]]
  #   else 
  #     project = Project.find_by_path(req.path, "/projects/")
  #     return [200, { 'Content-Type' => 'application/json' }, [ {:message => "project successfully requested", :project => project}.to_json(:include => { :boards => {:include => :tasks}}) ]]
  #   end #check if all projects or specific project
    

  #   # projects post/create (tested)
  #   elsif req.path.match(/projects/) && req.post?
  #     hash = JSON.parse(req.body.read)
  #     project = Project.create_new_project_with_defaults(hash)

  #     if project.save
  #       return [200, { 'Content-Type' => 'application/json' }, [ {:message => "project successfully created", :project => project}.to_json(:include => :tasks) ]]
  #     else
  #       return [422, { 'Content-Type' => 'application/json' }, [ {:error => "project not added"}.to_json ]]
  #     end #end validation of post

  #   # projects patch/update (tested)
  #   elsif req.path.match(/projects/) && req.patch?
  #     project = Project.find_by_path(req.path, "/projects/")

  #     if project
  #       data = JSON.parse(req.body.read)
  #       if project.update(data)
  #         return [200, {"Content-Type" => "application/json"}, [{message: "project successfully updated", project: project}.to_json]]
  #       else
  #         return [422, {"Content-Type" => "application/json"}, [{error: "project not updated. Invalid data."}.to_json]]
  #       end
  #       #if: project was updated
  #     else
  #       return [404, {"Content-Type" => "application/json"}, [{error: "project not found."}.to_json]]
  #     end #if : project exists

  #   # project delete
  #   elsif req.path.match(/projects/) && req.delete?
  #     project = Project.find_by_path(req.path, "/projects/")

  #     if project && project.destroy
  #       return [200, {"Content-Type" => "application/json"}, [{message: "project successfully deleted", project: project}.to_json]]
  #     else
  #       return [404, {"Content-Type" => "application/json"}, [{error: "project not found."}.to_json]]
  #     end #if : project exists

  #   # boards get/read (tested)
  #   elsif req.path.match(/boards/) && req.get?
  #     return [200, { 'Content-Type' => 'application/json' }, [ {:message => "boards successfully requested", :boards => Board.render_all_formatted_for_frontend}.to_json ]]


  #   # boards post/create (tested)
  #   elsif req.path.match(/boards/) && req.post? 
  #     # parse JSON into a readable format for my back-end
  #     hash = JSON.parse(req.body.read)
  #     # check if the project ID passed in exists
  #     project = Project.find_by_id(hash["project_id"])

  #     # if project id was valid move on to creating the new board
  #     if project 
  #       board = Board.new(name: hash["name"], project_id: hash["project_id"])
  #       if board.save
  #         return [200, { 'Content-Type' => 'application/json' }, [ {:message => "board successfully created", :board => board}.to_json ]]
  #       else
  #         return [422, { 'Content-Type' => 'application/json' }, [ {:error => "board not added. Invalid Data"}.to_json ]]
  #       end #end validation of post
  #     else
  #       return [422, { 'Content-Type' => 'application/json' }, [ {:error => "board not added. Invalid Project Id."}.to_json ]]
  #     end #if: check if project exists
      
  #   # boards patch/update (tested)
  #   elsif req.path.match(/boards/) && req.patch?
  #     board = Board.find_by_path(req.path, "/boards/")

  #     if board 
  #       data = JSON.parse(req.body.read)

  #       if board.update(data)
  #        return [200, {"Content-Type" => "application/json"}, [{message: "board successfully updated", board: board}.to_json]]
  #       else
  #         return [422, {"Content-Type" => "application/json"}, [{error: "board not updated. Invalid data."}.to_json]]
  #       end # if: update was successful

  #     else
  #       return [404, {"Content-Type" => "application/json"}, [{error: "board not found."}.to_json]]
  #     end #if : board exists

  #   # boards delete (tested)
  #   elsif req.path.match(/boards/) && req.delete?
  #     board = Board.find_by_path(req.path, "/boards/")

  #     if board && board.destroy
  #       return [200, {"Content-Type" => "application/json"}, [{message: "board successfully deleted", board: board}.to_json]]
  #     else
  #       return [404, {"Content-Type" => "application/json"}, [{error: "board not found."}.to_json]]
  #     end #if : board exists & destroyed


  #   # tasks get/read (tested)
  #   elsif req.path.match(/tasks/) && req.get?
  #     return [200, { 'Content-Type' => 'application/json' }, [ {:message => "tasks successfully requested", :tasks => Task.render_all_formatted_for_frontend}.to_json ]]

  #   # tasks post/create (tested)
  #   elsif req.path.match(/tasks/) && req.post?
  #     hash = JSON.parse(req.body.read)
  #     board = Board.find_by_id(hash["board_id"])

  #     if board 
  #       task = Task.create_new_task_with_defaults(hash) #custom method

  #       if task.save
  #         return [200, { 'Content-Type' => 'application/json' }, [ {:message => "task successfully created", :task => task}.to_json ]]
  #       else
  #         return [422, { 'Content-Type' => 'application/json' }, [ {:error => "task not added. Invalid Data"}.to_json ]]
  #       end #end validation of post
  #     else
  #       return [422, { 'Content-Type' => 'application/json' }, [ {:error => "task not added. Invalid Board Id."}.to_json ]]
  #     end #if: check if board  exists

  #    # tasks patch/update (tested)
  #   elsif req.path.match(/tasks/) && req.patch?
  #     task = Task.find_by_path(req.path, "/tasks/")

  #     if task 
  #       data = JSON.parse(req.body.read)

  #       if task.update(data)
  #       return [200, {"Content-Type" => "application/json"}, [{message: "task successfully updated", task: task}.to_json]]
  #       else
  #         return [422, {"Content-Type" => "application/json"}, [{error: "task not updated. Invalid data."}.to_json]]
  #       end # if: update was successful

  #     else
  #       return [404, {"Content-Type" => "application/json"}, [{error: "task not found."}.to_json]]
  #     end #if : task exists

  #   # tasks delete (tested)
  #   elsif req.path.match(/tasks/) && req.delete?
  #     task = Task.find_by_path(req.path, "/tasks/")

  #     if task && task.destroy
  #       return [200, {"Content-Type" => "application/json"}, [{message: "task successfully deleted", task: task}.to_json]]
  #     else
  #       return [404, {"Content-Type" => "application/json"}, [{error: "task not found."}.to_json]]
  #     end #if : task exists & destroyed

      

  #   else
  #     resp.write "Good luck with your project!"

  #   end

  #   resp.finish
  # end

end