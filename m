From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V33 02/30] security: Add a "locked down" LSM hook
Date: Fri, 21 Jun 2019 12:29:15 -0700
Message-ID: <CACdnJuusHEWFMfZmCvyaK=c40Z=4HM7sk1y0BaFs1OMbjKc-jQ@mail.gmail.com>
References: <20190621011941.186255-1-matthewgarrett@google.com>
 <20190621011941.186255-3-matthewgarrett@google.com> <201906202022.B09ED6E0@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201906202022.B09ED6E0@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 8:23 PM Kees Cook <keescook@chromium.org> wrote:

> bikeshed: can this just be called "security_locked_down" without the
> "is"?

Sure.
