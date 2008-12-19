From: y@redhat.com
Subject: [PATCH v5 0/6] Add preadv & pwritev system calls.
Date: Fri, 19 Dec 2008 16:58:19 +0100
Message-ID: <6412.69132397628$1229702506@news.gmane.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752363AbYLSP7a@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

  Hi folks,

Next round of the preadv & pwritev patch series, addressing review
comments:

 * Common code for the compat syscall versions is factored
   out in preparing patches.  
 * Added prototypes to syscall.h
 * Fixup some whitespace damage.

It's also the last release before I fall off the internet for the x-mas
and new-year holidays.  I'll be online again starting Jan 5th and will
deal with the remaining issues (if any) then.

cheers,
  Gerd
