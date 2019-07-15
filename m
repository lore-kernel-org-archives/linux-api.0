From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V35 00/29] Kernel lockdown functionality
Date: Mon, 15 Jul 2019 12:59:17 -0700
Message-ID: <20190715195946.223443-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Minor updates to the previous patchset to take some review comments into
account - no significant changes in functionality, other than that the
eBPF patch now only disables the kernel read functions as requested.
