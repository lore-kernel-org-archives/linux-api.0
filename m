From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V37 04/29] Enforce module signatures if the kernel is
 locked down
Date: Thu, 8 Aug 2019 11:31:09 -0700
Message-ID: <CACdnJuu6gFQUQQOVj2MwL5+dx+XsBKY=Uq58r7F8Lr2C0Gi_TA@mail.gmail.com>
References: <20190731221617.234725-1-matthewgarrett@google.com>
 <20190731221617.234725-5-matthewgarrett@google.com> <20190801142157.GA5834@linux-8ccs>
 <CACdnJusD_9W9tFqwKptDTA8fZU8HrSvsEQhKo0WS9QxLpgz5tA@mail.gmail.com> <20190808100059.GA30260@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190808100059.GA30260@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 8, 2019 at 3:01 AM Jessica Yu <jeyu@kernel.org> wrote:
> If you're confident that a hard dependency is not the right approach,
> then perhaps we could add a comment in the Kconfig (You could take a
> look at the comment under MODULE_SIG_ALL in init/Kconfig for an
> example)? If someone is configuring the kernel on their own then it'd
> be nice to let them know, otherwise having a lockdown kernel without
> module signatures would defeat the purpose of lockdown no? :-)

James, what would your preference be here? Jessica is right that not
having CONFIG_MODULE_SIG enabled means lockdown probably doesn't work
as expected, but tying it to the lockdown LSM seems inappropriate when
another LSM could be providing lockdown policy and run into the same
issue. Should this just be mentioned in the CONFIG_MODULE_SIG Kconfig
help?
