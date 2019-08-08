From: Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH V37 04/29] Enforce module signatures if the kernel is
 locked down
Date: Thu, 8 Aug 2019 12:01:00 +0200
Message-ID: <20190808100059.GA30260@linux-8ccs>
References: <20190731221617.234725-1-matthewgarrett@google.com>
 <20190731221617.234725-5-matthewgarrett@google.com>
 <20190801142157.GA5834@linux-8ccs>
 <CACdnJusD_9W9tFqwKptDTA8fZU8HrSvsEQhKo0WS9QxLpgz5tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJusD_9W9tFqwKptDTA8fZU8HrSvsEQhKo0WS9QxLpgz5tA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

+++ Matthew Garrett [01/08/19 13:42 -0700]:
>On Thu, Aug 1, 2019 at 7:22 AM Jessica Yu <jeyu@kernel.org> wrote:
>> Apologies if this was addressed in another patch in your series (I've
>> only skimmed the first few), but what should happen if the kernel is
>> locked down, but CONFIG_MODULE_SIG=n? Or shouldn't CONFIG_SECURITY_LOCKDOWN_LSM
>> depend on CONFIG_MODULE_SIG? Otherwise I think we'll end up calling
>> the empty !CONFIG_MODULE_SIG module_sig_check() stub even though
>> lockdown is enabled.
>
>Hm. Someone could certainly configure their kernel in that way. I'm
>not sure that tying CONFIG_SECURITY_LOCKDOWN_LSM to CONFIG_MODULE_SIG
>is the right solution, since the new LSM approach means that any other
>LSM could also impose the same policy. Perhaps we should just document
>this?

Hi Matthew,

If you're confident that a hard dependency is not the right approach,
then perhaps we could add a comment in the Kconfig (You could take a
look at the comment under MODULE_SIG_ALL in init/Kconfig for an
example)? If someone is configuring the kernel on their own then it'd
be nice to let them know, otherwise having a lockdown kernel without
module signatures would defeat the purpose of lockdown no? :-)

Thank you,

Jessica
