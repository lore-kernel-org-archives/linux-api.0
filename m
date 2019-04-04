From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V32 0/27] Lockdown patches for 5.2
Date: Wed,  3 Apr 2019 17:32:22 -0700
Message-ID: <20190404003249.14356-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org
List-Id: linux-api@vger.kernel.org

Fairly minimal changes since the last set: tracefs is restricted at
Steven's suggestion (but could do with a once-over, I'm very much not a
vfs person), debugfs is back to Dave's original implementation. I've
also fixed up a malformed patch that resulted from me getting confused
during rebase, and added some further documentation to the initial patch
in order to give a reference for the design goals.
