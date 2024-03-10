from PIL import Image
from pathlib import Path
import tqdm
import numpy as np

frames_path = Path('frames')
lua_frames_path = Path('lua_frames')

for frame in tqdm.tqdm(list(frames_path.glob('*.png'))):
    fname = frame.name
    lua_frame = (lua_frames_path / fname).with_suffix('.txt')
    with Image.open(frame) as img:
        n_img = img.resize((39 * 4 // 3, 39), Image.Resampling.LANCZOS).convert('1')
        np_img = np.array(n_img)
        lua_frame_data = []
        for i in range(39):
            row = np_img[i,:]
            ri = 38 - i

            delta = np.diff(row, prepend=False, append=False)
            idx = np.arange(delta.size)
            assert idx[delta].size % 2 == 0, 'WOAHG'
            txt_delta_idx = ', '.join([str(x) for x in idx[delta]])
            lua_frame_data.append(f'{ri}: {txt_delta_idx}\n')
        with open(lua_frame, 'w') as f:
            for line in reversed(lua_frame_data):
                f.write(line)
