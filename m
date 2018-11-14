From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 09:58:15 -0500
Message-ID: <fb340c72-c484-7f55-a2bd-71e072d7f1f5@redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com>
 <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Daniel Colascione <dancol@google.com>
Cc: nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/14/18 6:58 AM, Szabolcs Nagy wrote:
> an actual proposal in the thread that i think is
> worth considering is to make the linux syscall
> design process involve libc devs so the c api is
> designed together with the syscall abi.

Right, I see at least 2 actionable items:

* "The Checklist" which everyone making a syscall should
  follow and we create the checklist with input from both
  sides and it becomes the thing you reference e.g.
  "Did you follow the checklist? Where is X?"

* Programmatic / Machine readable description of syscalls.
  This way the kernel gives users the ability to autogenerate
  all the wrappers *if they want to* in a consistent way that
  matches this syscall description format.

-- 
Cheers,
Carlos.
