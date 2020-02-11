From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 01/24] user_namespace: introduce fsid mappings
 infrastructure
Date: Tue, 11 Feb 2020 09:26:17 -0800
Message-ID: <25217d8b-f3e9-7362-e3d9-d8c37bf39558@infradead.org>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
 <20200211165753.356508-2-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-2-christian.brauner@ubuntu.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/11/20 8:57 AM, Christian Brauner wrote:
> diff --git a/init/Kconfig b/init/Kconfig
> index a34064a031a5..4da082e4f787 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1102,6 +1102,17 @@ config USER_NS
>  
>  	  If unsure, say N.
>  
> +config USER_NS_FSID
> +	bool "User namespace fsid mappings"
> +	depends on USER_NS
> +	default n
> +	help
> +	  This allows containers, to alter their filesystem id mappings.

                   no comma   ^^^^

> +	  With this containers with different id mappings can still share
> +	  the same filesystem.
> +
> +	  If unsure, say N.
> +
>  config PID_NS
>  	bool "PID Namespaces"
>  	default y


-- 
~Randy
