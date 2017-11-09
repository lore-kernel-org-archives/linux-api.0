From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v2 4/4] mm/mempolicy: add nodes_empty check in
 SYSC_migrate_pages
Date: Thu, 9 Nov 2017 09:46:42 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711090946130.12483@nuc-kabylake>
References: <1509099265-30868-1-git-send-email-xieyisheng1@huawei.com> <1509099265-30868-5-git-send-email-xieyisheng1@huawei.com> <dccbeccc-4155-94a8-0e67-b7c28238896d@suse.cz> <bc57f574-92f2-0b69-4717-a1ec7170387c@huawei.com> <d774ecf6-5e7b-e185-85a0-27bf2bcacfb4@suse.cz>
 <alpine.DEB.2.20.1711060926001.9015@nuc-kabylake> <a4f1212f-3903-abbc-772a-1ddee6f7f98b@huawei.com> <alpine.DEB.2.20.1711070851560.18776@nuc-kabylake> <04e4cb50-8cba-58af-1a5e-61e818cffa70@suse.cz> <alpine.DEB.2.20.1711070948410.19176@nuc-kabylake>
 <4b08f1e9-5449-6ea2-e7da-65fe5f678683@huawei.com> <alpine.DEB.2.20.1711080900050.6161@nuc-kabylake> <9991dd10-8883-7c82-bb4e-8145ea2b7299@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9991dd10-8883-7c82-bb4e-8145ea2b7299-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, salls-b3bnyZ7c9ISVc3sceRu5cw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tanxiaojun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 9 Nov 2017, Yisheng Xie wrote:

> > The caller of migrate_pages should be able to migrate the target process
> > pages anywhere the caller can allocate memory. If that is outside the
> > target processes cpuset then that is fine. Pagecache pages that are not
> > allocated by the target process already are not subject to the target
> > processes restriction. So this is not that unusual.
>
> So there is no need to check the restriction of target process cpuset, right?
> I hope that I do not miss anything :)

Exactly.
