From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 03/30] security: Add a static lockdown policy LSM
Date: Fri, 21 Jun 2019 14:04:08 -0700
Message-ID: <CACdnJutWhpgKeWWBv8AkTxBxoVempiuVRJzk7mrUF6LMmnwp4Q@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-4-matthewgarrett@google.com> <201906202028.5AB58C3@keescook>
 <CACdnJut_C_h2JjryDxEm9U_rpSJFkVyxq3iCW9=AhwcdVig=9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJut_C_h2JjryDxEm9U_rpSJFkVyxq3iCW9=AhwcdVig=9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 12:37 PM Matthew Garrett <mjg59@google.com> wrote:
> I'll check, I'm bad at finding these new fangled things.

Ah, I see - there's sysfs_match_string(), but that doesn't really work
for this case because we'd still need to do another set of checks to
see whether the level we get is in lockdown_levels, not just
lockdown_reasons.
