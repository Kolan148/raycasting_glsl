import moderngl_window as mglw
import keyboard as kb

class App(mglw.WindowConfig):
    window_size = 1600, 900
    resource_dir = 'programs'

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.quad = mglw.geometry.quad_fs()
        self.program = self.load_program(vertex_shader='vertex.glsl', fragment_shader='fragment.glsl')
        # uniforms
        self.program['u_resolution'] = self.window_size
        self.x = 0
        self.y = 0
        self.z = 0
        self.a1 = 0.0
        self.a2 = 0.0

    def render(self, time, frame_time):
        self.ctx.clear()
        if kb.is_pressed('d'):self.x += 0.05
        if kb.is_pressed('a'):self.x -= 0.05
        if kb.is_pressed('w'):self.z += 0.05
        if kb.is_pressed('s'):self.z -= 0.05
        if kb.is_pressed('q'):self.y += 0.05
        if kb.is_pressed('e'):self.y -= 0.05
        if kb.is_pressed('Left'):self.a1+=0.01
        if kb.is_pressed('Right'):self.a1-=0.01
        if kb.is_pressed('Up'):self.a2+=0.01
        if kb.is_pressed('Down'):self.a2-=0.01
        self.program['x'] = self.x
        self.program['y'] = self.y
        self.program['z'] = self.z
        self.program['a1'] = self.a1
        self.program['a2'] = self.a2
        #self.program['u_time'] = time
        self.quad.render(self.program)

    #def mouse_position_event(self, x, y, dx, dy):
    #    self.program['u_mouse'] = (x, y)


if __name__ == '__main__':
    mglw.run_window_config(App)
