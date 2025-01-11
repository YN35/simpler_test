import argparse
import torch
import simpler_env
from simpler_env.utils.env.observation_utils import get_image_from_maniskill2_obs_dict
from torchvision.io import write_video


def main(task: str = "google_robot_pick_coke_can"):
    env = simpler_env.make(task)
    obs, reset_info = env.reset()
    instruction = env.get_language_instruction()
    print("Reset info", reset_info)
    print("Instruction", instruction)

    # 動画用のフレームリストを用意
    frames = []

    # 初期画像を取得して保存
    image = get_image_from_maniskill2_obs_dict(env, obs)
    print("Image shape and dtype", image.shape, image.dtype)
    frames.append(image)

    done, truncated = False, False
    step = 0
    while not (done or truncated):
        image = get_image_from_maniskill2_obs_dict(env, obs)
        action = env.action_space.sample()  # policy inferenceに置き換え可能
        if step == 0:
            print("Action shape and dtype", action.shape, action.dtype)
            print("Action", action)
        obs, reward, done, truncated, info = env.step(action)
        new_instruction = env.get_language_instruction()
        if new_instruction != instruction:
            instruction = new_instruction
            print("New Instruction", instruction)
        print("Step", step, "Reward", reward, "Done", done, "Truncated", truncated)

        # 毎ステップの画像をフレームリストに追加
        frames.append(image)
        step += 1

    episode_stats = info.get("episode_stats", {})
    print("Episode stats", episode_stats)

    # torchvision.io.write_videoを用いて動画を保存
    # framesは NumPy の ndarray のリストになっているので、torch.Tensorに変換して shape を (num_frames, H, W, 3) にする
    video_array = torch.as_tensor(frames)  # uint8のTensor
    filename = "output_video.mp4"
    fps = 10  # 必要に応じてFPSを変更してください

    # 動画を保存
    write_video(filename, video_array, fps=fps)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", type=str, default="google_robot_pick_coke_can")
    args = parser.parse_args()

    print("=====================================")
    print("Available environments:")
    print(simpler_env.ENVIRONMENTS)
    print("=====================================")
    print("Running task", args.task)
    main(args.task)
