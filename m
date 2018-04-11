From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running
 kernel image
Date: Wed, 11 Apr 2018 15:38:27 -0700
Message-ID: <CA+55aFzvnf=4OeBy5vQQ6HQoCsgCkAJw1LhSBOTkDWm3ck1pZA@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
 <CA+55aFzPo-dip8dgyo0U+g5qai9SAJU+D1c+AFJ0zV9_PBAB8Q@mail.gmail.com> <8z0aRQyD-6Krqntk8UD9WQjK5JSqEai2Pt5oeFU2EplgxoWiHlX5nlJXwCDHQ1WcS1oIprXimgz7UvwHCWDB9Z3dYFrEmZmtkEJSqaYMel8=@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8z0aRQyD-6Krqntk8UD9WQjK5JSqEai2Pt5oeFU2EplgxoWiHlX5nlJXwCDHQ1WcS1oIprXimgz7UvwHCWDB9Z3dYFrEmZmtkEJSqaYMel8=@protonmail.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: David Howells <dhowells@redhat.com>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 2:05 PM, Jordan Glover
<Golden_Miller83@protonmail.ch> wrote:
>>
>> If that /dev/mem access prevention was just instead done as an even
>> stricter mode of the existing CONFIG_STRICT_DEVMEM, it could just be
>> enabled unconditionally.
>
> CONFIG_DEVMEM=n

It's actually CONFIG_DEVMEM, CONFIG_DEVKMEM and CONFIG_DEVPORT, it's
just not obvious from the patch.

But the important part is this part:

>> So I would seriously ask that the distros that have been using these
>> patches look at which parts of lockdown they could make unconditional
>> (because it doesn't break machines), and which ones need that escape
>> clause.

.. because I get the feeling that not a lot of people have actually
been testing this, because "turn off secure boot" is such a universal
thing when people boot Linux.

So it's really the whole claim that distributions have been running
for this for the last five years that I wonder about, and how often
people end up being told: "just disable secure boot":.

But if people really don't need DEVMEM/DEVKMEM/DEVPORT, maybe we
should just disable them in the default configs, and consider them
legacy.

I'm just surprised. I suspect a lot of people end up actually using
devmem as a fallback for dmidecode etc. Maybe those people don't boot
with EFI secure mode, but if so that just shows that this whole
"hardening" is just security theater.

              Linus
