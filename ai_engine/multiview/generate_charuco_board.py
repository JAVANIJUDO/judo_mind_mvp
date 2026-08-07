from pathlib import Path

import cv2
import numpy as np
from PIL import Image


OUTPUT_DPI = 300

A4_WIDTH_PX = 2480
A4_HEIGHT_PX = 3508

SQUARES_X = 7
SQUARES_Y = 5

SQUARE_LENGTH_MM = 25.0
MARKER_LENGTH_MM = 18.0


def mm_to_pixels(
    millimeters: float,
) -> int:
    inches = millimeters / 25.4

    return round(
        inches * OUTPUT_DPI
    )


def generate_board() -> None:
    output_directory = (
        Path(__file__).resolve().parent.parent
        / "runtime"
        / "calibration"
    )

    output_directory.mkdir(
        parents=True,
        exist_ok=True,
    )

    dictionary = (
        cv2.aruco.getPredefinedDictionary(
            cv2.aruco.DICT_6X6_250
        )
    )

    board = cv2.aruco.CharucoBoard(
        (
            SQUARES_X,
            SQUARES_Y,
        ),
        SQUARE_LENGTH_MM,
        MARKER_LENGTH_MM,
        dictionary,
    )

    board_width = mm_to_pixels(
        SQUARES_X
        * SQUARE_LENGTH_MM
    )

    board_height = mm_to_pixels(
        SQUARES_Y
        * SQUARE_LENGTH_MM
    )

    board_image = board.generateImage(
        (
            board_width,
            board_height,
        ),
        marginSize=0,
        borderBits=1,
    )

    page = np.full(
        (
            A4_HEIGHT_PX,
            A4_WIDTH_PX,
        ),
        255,
        dtype=np.uint8,
    )

    offset_x = (
        A4_WIDTH_PX
        - board_width
    ) // 2

    offset_y = (
        A4_HEIGHT_PX
        - board_height
    ) // 2

    page[
        offset_y:
        offset_y + board_height,
        offset_x:
        offset_x + board_width,
    ] = board_image

    cv2.putText(
        page,
        "JUDO MIND MULTI-VIEW CALIBRATION",
        (
            140,
            180,
        ),
        cv2.FONT_HERSHEY_SIMPLEX,
        1.25,
        0,
        3,
        cv2.LINE_AA,
    )

    cv2.putText(
        page,
        (
            "ChArUco 7x5 | "
            "Square: 25 mm | "
            "Marker: 18 mm"
        ),
        (
            140,
            240,
        ),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.75,
        0,
        2,
        cv2.LINE_AA,
    )

    cv2.putText(
        page,
        (
            "PRINT AT 100% / ACTUAL SIZE"
        ),
        (
            140,
            300,
        ),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.75,
        0,
        2,
        cv2.LINE_AA,
    )

    png_path = (
        output_directory
        / "judo_mind_charuco_a4.png"
    )

    pdf_path = (
        output_directory
        / "judo_mind_charuco_a4.pdf"
    )

    image = Image.fromarray(page)

    image.save(
        png_path,
        dpi=(
            OUTPUT_DPI,
            OUTPUT_DPI,
        ),
    )

    image.convert("RGB").save(
        pdf_path,
        "PDF",
        resolution=OUTPUT_DPI,
    )

    print(
        "Judo Mind ChArUco Board: READY"
    )

    print(
        f"PNG: {png_path}"
    )

    print(
        f"PDF: {pdf_path}"
    )

    print(
        "Board physical size: "
        f"{SQUARES_X * SQUARE_LENGTH_MM:.0f}"
        " x "
        f"{SQUARES_Y * SQUARE_LENGTH_MM:.0f}"
        " mm"
    )

    print(
        "Each square must measure exactly "
        f"{SQUARE_LENGTH_MM:.0f} mm "
        "after printing."
    )


if __name__ == "__main__":
    generate_board()