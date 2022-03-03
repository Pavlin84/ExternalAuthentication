namespace ExternalAuthentication.Web.Areas.Administration.Controllers
{
    using ExternalAuthentication.Common;
    using ExternalAuthentication.Web.Controllers;

    using Microsoft.AspNetCore.Authorization;
    using Microsoft.AspNetCore.Mvc;

    [Authorize(Roles = GlobalConstants.AdministratorRoleName)]
    [Area("Administration")]
    public class AdministrationController : BaseController
    {
    }
}
