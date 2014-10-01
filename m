From: Daniel Micay <danielmicay@gmail.com>
Subject: Re: [PATCH v3] mm: add mremap flag for preserving the old mapping
Date: Tue, 30 Sep 2014 22:32:33 -0400
Message-ID: <542B67C1.9080303@gmail.com>
References: <1412052900-1722-1-git-send-email-danielmicay@gmail.com> <CALCETrX6D7X7zm3qCn8kaBtYHCQvdR06LAAwzBA=1GteHAaLKA@mail.gmail.com> <542A79AF.8060602@gmail.com> <CALCETrVHgvhAN3neoOpJEk94uM7QKm2izZpp+=1UA6qieaQiTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALCETrVHgvhAN3neoOpJEk94uM7QKm2izZpp+=1UA6qieaQiTQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jason Evans <jasone@canonware.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 30/09/14 01:49 PM, Andy Lutomirski wrote:
>=20
> I think it might pay to add an explicit vm_op to authorize
> duplication, especially for non-cow mappings.  IOW this kind of
> extension seems quite magical for anything that doesn't have the
> normal COW semantics, including for plain old read-only mappings.

This sounds like the best way forwards.

Setting up the op for private, anonymous mappings and having it check
vm_flags & VM_WRITE dynamically seems like it would be enough for the
intended use case in general purpose allocators. It can be extended to
other mapping types later if there's a compelling use case.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
