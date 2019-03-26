From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V31 25/25] debugfs: Disable open() when kernel is locked down
Date: Tue, 26 Mar 2019 12:21:56 -0700
Message-ID: <CACdnJuuZmPymMMFxGgUy8Wm-msWS+MztpXE-HNPzX96WRUKbqQ@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-26-matthewgarrett@google.com> <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXDF2c2-gnOyNTnEn-uPAZp0AaSB_PB8e2y8jf7zo=Cyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 26, 2019 at 12:20 PM Andy Lutomirski <luto@kernel.org> wrote:
> Ugh.  Some of those files are very useful.  Could this perhaps still
> allow O_RDONLY if we're in INTEGRITY mode?

The previous implementation did, but Greg wanted it to go away entirely.
