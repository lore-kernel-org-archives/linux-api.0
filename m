From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 12:46:39 +0100
Message-ID: <87k18p6qjk.fsf@mid.deneb.enyo.de>
References: <157225848971.557.16257813537984792761.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157225848971.557.16257813537984792761.stgit@buzz> (Konstantin
        Khlebnikov's message of "Mon, 28 Oct 2019 13:28:09 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

* Konstantin Khlebnikov:

> This implements fcntl() for getting amount of resident memory in cache.
> Kernel already maintains counter for each inode, this patch just exposes
> it into userspace. Returned size is in kilobytes like values in procfs.

I think this needs a 32-bit compat implementation which clamps the
returned value to INT_MAX.
