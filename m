From: Martin Hostettler <textshell@uchuujin.de>
Subject: vt: Improve CSI parsing
Date: Sat, 15 Dec 2018 15:34:19 +0100
Message-ID: <20181215143423.4556-1-textshell@uchuujin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>, Adam Borowski <kilobyte@angband.pl>, Egmont Koblinger <egmont@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch series improves parsing of csi sequences to be more compliant
with current practice.

ECMA-64 defines the format of CSI sequences which allow more characters
than what the vt parser currently accepts. More importantly many of
these characters are used in sequences that more capable terminal
terminal implementations use.

Adjust the parsing of CSI sequences to match xterm* by ignoring all
unknown sequences of the form
   (ESC [)|CSI [\x20-\x3f]*[\x40-\x7e]

This avoids printing unwanted characters when application send valid
sequences not supported by linux either while querying the terminal for
it's identity or when applications print sequences without knowing what
terminal implementation they are connected to (e.g. when connected over
serial lines, android's adb, simple tcp connects, etc)

* and other common terminals
