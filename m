From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 15/45] dm-log-userspace.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 13:38:06 +0000
Message-ID: <20150217133806.GA5220@agk-dp.fab.redhat.com>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-16-git-send-email-mikko.rapeli@iki.fi> <2309592.iOl8K3u7d8@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2309592.iOl8K3u7d8@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 10:08:56AM +0100, Arnd Bergmann wrote:
> The normal way to do this in kernel headers is to use linux/types.h
> but change the data structures to use __u64 instead of uint64_t
> to avoid the build error.
 
That's what happened to dm-ioctl.h.
(Or someone could adjust linux/types.h to include these as standard.)

Alasdair
