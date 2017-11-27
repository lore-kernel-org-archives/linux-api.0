From: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 20:28:27 +0100
Message-ID: <CAM43=SOAU2-qTB2cHeZs5xGzPFKwoqtTafqtw+BqCP9cbQDUOQ@mail.gmail.com>
References: <23066.59196.909026.689706@gargle.gargle.HOWL> <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <20171127162207.GA8265@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171127162207.GA8265-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 5:22 PM, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> Could you be more explicit about _why_ we need to remove this tunable?
>> I am not saying I disagree, the removal simplifies the code but I do not
>> really see any justification here.
>
> I imagine he started seeing random syscalls failing with ENOMEM and
> eventually tracked it down to this stupid limit we used to need.

Exactly, except the origin (mmap() failing) was hidden behind layers upon layers
of user-space memory management code (not ours), which just said "failed to
allocate N bytes" (with N about 0.001% of the free RAM).  And it
wasn't reproducible.
