From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Thu, 30 Oct 2014 10:51:29 +0100
Message-ID: <54520A21.20404@samsung.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz> <20141029231106.GB16548@kroah.com> <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz> <20141029234001.GB16520@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141029234001.GB16520@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2014-10-30 00:40, Greg Kroah-Hartman wrote:

> There is a 1815 line documentation file in this series, so we aren't
> trying to not provide this type of information here at all.  But yes,
> more background, about why this can't be done in userspace (zero copy,
> less context switches, proper credential passing, timestamping, availble
> at early-boot, LSM hooks for security models to tie into

While you're at it... I have worked on proof-of-concept LSM patches for
kdbus some time ago, see [1][2].  Currently, these are completely of date.

 [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
 [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40

May I ask if you guys have your own plan for LSM or maybe it would be
worth to resurrect [1]?

Cheers,
-- 
Karol Lewandowski, Samsung R&D Institute Poland
