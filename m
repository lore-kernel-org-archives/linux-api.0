From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH V40 03/29] security: Add a static lockdown policy LSM
Date: Fri, 30 Aug 2019 17:28:26 +0100
Message-ID: <3440.1567182506@warthog.procyon.org.uk>
References: <20190820001805.241928-4-matthewgarrett@google.com> <20190820001805.241928-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-4-matthewgarrett@google.com>
Content-ID: <3439.1567182506.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: dhowells@redhat.com, jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <mjg59@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Matthew Garrett <matthewgarrett@google.com> wrote:

> +static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {

const char *const maybe?

> +static enum lockdown_reason lockdown_levels[] = {LOCKDOWN_NONE,
> +						 LOCKDOWN_INTEGRITY_MAX,
> +						 LOCKDOWN_CONFIDENTIALITY_MAX};
> +

const?

Isn't this also a 1:1 mapping?

> +static int lock_kernel_down(const char *where, enum lockdown_reason level)

Is the last parameter the reason or the level?  You're mixing the terms.

David
