From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running
 kernel image
Date: Thu, 12 Apr 2018 09:52:54 -0700
Message-ID: <CA+55aFyEaNGLoSL2SJZkcvApPJQFo1mK9KW6g-_FdAm1KSqGEw@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
 <CA+55aFzPo-dip8dgyo0U+g5qai9SAJU+D1c+AFJ0zV9_PBAB8Q@mail.gmail.com>
 <8z0aRQyD-6Krqntk8UD9WQjK5JSqEai2Pt5oeFU2EplgxoWiHlX5nlJXwCDHQ1WcS1oIprXimgz7UvwHCWDB9Z3dYFrEmZmtkEJSqaYMel8=@protonmail.ch>
 <CA+55aFzvnf=4OeBy5vQQ6HQoCsgCkAJw1LhSBOTkDWm3ck1pZA@mail.gmail.com> <CAFxkdAr5c_bKEKqV2t-PKAo3iSvEkpqO1p+RPg9t-sW4yEUOnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFxkdAr5c_bKEKqV2t-PKAo3iSvEkpqO1p+RPg9t-sW4yEUOnw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Forbes <jmforbes@linuxtx.org>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>, David Howells <dhowells@redhat.com>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 12, 2018 at 6:09 AM, Justin Forbes <jmforbes@linuxtx.org> wrote:
> On Wed, Apr 11, 2018, 5:38 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So it's really the whole claim that distributions have been running
>> for this for the last five years that I wonder about, and how often
>> people end up being told: "just disable secure boot":.
>
> Very rarely in my experience.

Good. Do you have a handle on the reasons?

Because I'm assuming it's not /dev/{mem,kmem,port}? Because I'd really
be happier if we just say "those are legacy, don't enable them at all
for modern distros".

That way they'd _stay_ disabled even if somebody cannot handle the
other limitations, like DMA etc.

                 Linus
