awesome-retropunk
-----------------

An Awesome WM theme with gruvbox colors, cool widgets and features.

Features
--------

- Minimalist yet informative CPU and RAM stat graphs
- Fancy box showing MPD playing status and progress, with scrolling song title
- Pixelated style of icons with colors automatically extracted from the original application (see the chrome icon below)
- Sharp and clear client status (floating, maximized, etc.) icon

Preview
-------

.. image:: https://github.com/Determinant/awesome-retropunk/raw/master/screenshots/preview_front.png
   :scale: 100%

.. image:: https://github.com/Determinant/awesome-retropunk/raw/master/screenshots/preview_back.png
   :scale: 100%

Install
-------

- Checkout the repo content in your Awesome WM directory by ``git clone https://github.com/Determinant/awesome-retropunk.git ~/.config/awesome/``
- Checkout the subrepo by ``git submodule update --init --recursive``
- Run ``make all`` to compile the cairohack cpp file in the submodule
- Download and install the `cherry <https://github.com/turquoise-hexagon/cherry>`_ and `siji <https://github.com/stark/siji>`_ font
- Add the following lines to your ``~/.config/fontconfig/fonts.conf``

::

  <match>
      <test name="family">
          <string>pixel</string>
      </test>
      <edit binding="strong" mode="prepend" name="family">
          <string>cherry</string>
          <string>Siji</string>
          <string>WenQuanYi WenQuanYi Bitmap Song</string>
          <!-- Your other fonts here <string>Source Han Sans TC Normal</string> -->
      </edit>
      <edit name="antialias" mode="assign">
          <bool>false</bool>
      </edit>
  </match>
