From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCHSET v4 0/5] pagemap: make useable for non-privilege users
Date: Tue, 14 Jul 2015 11:52:52 -0700
Message-ID: <20150714115252.8f21cfa864935a4b403c3d8d@linux-foundation.org>
References: <20150714152516.29844.69929.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714152516.29844.69929.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 14 Jul 2015 18:37:34 +0300 Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:

> This patchset makes pagemap useable again in the safe way (after row hammer
> bug it was made CAP_SYS_ADMIN-only). This patchset restores access for
> non-privileged users but hides PFNs from them.

Documentation/vm/pagemap.txt hasn't been updated to describe these
privilege issues?

> Also it adds bit 'map-exlusive' which is set if page is mapped only here:
> it helps in estimation of working set without exposing pfns and allows to
> distinguish CoWed and non-CoWed private anonymous pages.
> 
> Second patch removes page-shift bits and completes migration to the new
> pagemap format: flags soft-dirty and mmap-exlusive are available only
> in the new format.

I'm not really seeing a description of the new format in these
changelogs.  Precisely what got removed, what got added and which
capabilities change the output in what manner?
