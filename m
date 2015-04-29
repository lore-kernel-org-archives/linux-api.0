From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Wed, 29 Apr 2015 13:33:54 -0700
Message-ID: <CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
	<CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
	<20150429193622.GA11892@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150429193622.GA11892-nhfs4B5ZimeFUdmeq17FyvUpdFzICT1y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 12:36 PM, Kirill A. Shutemov
<kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
>
> Emm.. I have hard time to understand how writable bit is enough to get
> soft-dirty-alike functionality.

I don't think it is.

For anonymous pages, maybe you can play tricks with comparing the page
'anon_vma' with the vma->anon_vma.

I haven't really thought that through, but does something like

   static inline bool page_is_dirty_in_vma(struct page *page, struct
vm_area_struct *vma)
   {
        struct anon_vma *anon_vma = vma->anon_vma;

        return page->mapping == (void *)anon_vma + PAGE_MAPPING_ANON;
   }

end up working as a "page has been dirtied in this mapping"?

If the page came from another process and hasn't been written to, it
will have the anon_vma pointing to the originalting vma.

I may be high on some bad drugs, though. As mentioned, I didn't really
think this through.

                        Linus
