From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V33 00/30] Lockdown as an LSM
Date: Thu, 20 Jun 2019 18:19:11 -0700
Message-ID: <20190621011941.186255-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi James,

Let's see how this one goes. I've moved the lockdown code into an LSM
hook and provided an internal enum of lockdown reasons that LSMs can
either group or expose at whatever level of granularity is appropriate.
I've also included a static LSM that mimics the behaviour of the
existing patchset. I think there's a reasonable discussion to have about
what sort of granularity other LSMs might want to offer, but I don't
think that necessarily needs to be a blocker to merging this.

As with the last implementation, this can be enabled via static kernel
configuration, the kernel command line or via securityfs, depending on
usecase. Distributions may wish to tie it to UEFI Secure Boot state, but
we can save that conversation to later.

Thoughts?
