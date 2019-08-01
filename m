From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V37 04/29] Enforce module signatures if the kernel is
 locked down
Date: Thu, 1 Aug 2019 13:42:31 -0700
Message-ID: <CACdnJusD_9W9tFqwKptDTA8fZU8HrSvsEQhKo0WS9QxLpgz5tA@mail.gmail.com>
References: <20190731221617.234725-1-matthewgarrett@google.com>
 <20190731221617.234725-5-matthewgarrett@google.com> <20190801142157.GA5834@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190801142157.GA5834@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 1, 2019 at 7:22 AM Jessica Yu <jeyu@kernel.org> wrote:
> Apologies if this was addressed in another patch in your series (I've
> only skimmed the first few), but what should happen if the kernel is
> locked down, but CONFIG_MODULE_SIG=n? Or shouldn't CONFIG_SECURITY_LOCKDOWN_LSM
> depend on CONFIG_MODULE_SIG? Otherwise I think we'll end up calling
> the empty !CONFIG_MODULE_SIG module_sig_check() stub even though
> lockdown is enabled.

Hm. Someone could certainly configure their kernel in that way. I'm
not sure that tying CONFIG_SECURITY_LOCKDOWN_LSM to CONFIG_MODULE_SIG
is the right solution, since the new LSM approach means that any other
LSM could also impose the same policy. Perhaps we should just document
this?
