From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V37 19/29] Lock down module params that specify hardware
 parameters (eg. ioport)
Date: Thu, 1 Aug 2019 13:44:10 -0700
Message-ID: <CACdnJutXUO9e0ti8tHtJ8z3xX6dcn4Cczbs-wMBRr07BM3iCvQ@mail.gmail.com>
References: <20190731221617.234725-1-matthewgarrett@google.com>
 <20190731221617.234725-20-matthewgarrett@google.com> <20190801161933.GB5834@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190801161933.GB5834@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 1, 2019 at 9:19 AM Jessica Yu <jeyu@kernel.org> wrote:

> Hm, I don't think the doing parameter ended up being used in this function?

Thanks for catching that, I'll fix.
