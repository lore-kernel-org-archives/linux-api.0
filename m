From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V40 00/29] Add kernel lockdown functionality
Date: Mon, 19 Aug 2019 17:17:36 -0700
Message-ID: <20190820001805.241928-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

After chatting with James in person, I'm resending the full set with the
fixes merged in in order to avoid any bisect issues. There should be no
functional changes other than avoiding build failures with some configs,
and fixing the oops in tracefs.
